/**
 * @fileoverview 滚动位置保存与恢复模块
 * @version 1.1
 * @author huajiqaq
 *
 * 使用 IndexedDB 保存页面滚动位置，并支持自动恢复、清理过期记录、删除特定数据等功能。
 */

(function () {

    // 配置项
    const config = {
        dbName: 'scroll-position-db',
        storeName: 'scroll-position',
        dbVersion: 1,
        expirationPeriod: 10 * 24 * 60 * 60 * 1000, // 10天
        debounceTime: 1000, // 滚动保存延迟时间
        scrollThreshold: 5, // 滚动变化阈值，小于该值不保存
        useFullUrlAsKey: true, // 是否使用完整URL作为键
    };

    /**
     * 获取当前页面唯一标识符
     * @returns {string}
     */
    function getCurrentPageKey() {
        return config.useFullUrlAsKey
            ? window.location.href
            : window.location.hostname + window.location.pathname;
    }

    /**
     * 工具函数：封装事务操作
     * @param {string} storeName
     * @param {'readonly'|'readwrite'} mode
     * @param {(store: IDBObjectStore, tx: IDBTransaction) => Promise<any>} callback
     * @returns {Promise<any>}
     */
    async function withTransaction(storeName, mode, callback) {
        const db = await openDB();
        if (!db) return null;

        const tx = db.transaction(storeName, mode);
        const store = tx.objectStore(storeName);
        let result;

        try {
            result = await callback(store, tx);
        } catch (e) {
            console.error("事务执行出错:", e);
            tx.abort();
        }

        await tx.done;
        return result;
    }

    /**
     * 打开或创建 IndexedDB 数据库
     * @returns {Promise<IDBDatabase|null>}
     */
    async function openDB() {
        if (!window.indexedDB) {
            console.warn("浏览器不支持 IndexedDB");
            return null;
        }

        return new Promise((resolve, reject) => {
            const request = indexedDB.open(config.dbName, config.dbVersion);

            request.onerror = () => {
                console.error("打开数据库失败:", request.error);
                resolve(null);
            };

            request.onupgradeneeded = event => {
                const db = event.target.result;
                if (!db.objectStoreNames.contains(config.storeName)) {
                    const store = db.createObjectStore(config.storeName, { keyPath: 'url' });
                    store.createIndex('url', 'url', { unique: true });
                }
            };

            request.onsuccess = () => resolve(request.result);
        });
    }

    /**
     * 保存当前滚动位置
     */
    async function saveScrollPosition() {
        const url = getCurrentPageKey();
        const position = window.scrollY;
        const timestamp = Date.now();

        await withTransaction(config.storeName, 'readwrite', store => {
            store.put({ url, position, timestamp });
        });

        console.info("已保存滚动位置", { url, position, timestamp });
    }
    

    /**
     * 恢复滚动位置，并暴露恢复的 scrollY 值
     */
    async function restoreScrollPosition() {
        const url = getCurrentPageKey();

        const data = await withTransaction(config.storeName, 'readonly', store => {
            return new Promise((resolve, reject) => {
                const request = store.get(url);
                request.onsuccess = () => resolve(request.result);
                request.onerror = () => reject(request.error);
            });
        });

        if (data && data.position > 10) {
            // 设置全局变量供外部访问
            window.scrollRestorerPos = data.position;
            window.scrollTo({ top: data.position, behavior: 'smooth' });
            console.info("已恢复滚动位置", data);
        } else {
            // 如果没有找到记录，删除全局变量
            delete window.scrollRestorerPos;
        }
    }

    /**
     * 清理过期的滚动位置记录
     */
    async function clearExpiredEntries() {
        const now = Date.now();

        await withTransaction(config.storeName, 'readwrite', store => {
            return new Promise(resolve => {
                const cursorRequest = store.openCursor();
                cursorRequest.onsuccess = () => {
                    const cursor = cursorRequest.result;
                    if (cursor) {
                        if (cursor.value.timestamp < now - config.expirationPeriod) {
                            cursor.delete();
                        }
                        cursor.continue();
                    } else {
                        resolve();
                    }
                };
                cursorRequest.onerror = () => {
                    console.error("游标遍历失败");
                    resolve();
                };
            });
        });

        console.info("已完成过期记录清理");
    }

    /**
     * 删除当前页面的滚动位置记录
     */
    async function deleteCurrentPageData() {
        const url = getCurrentPageKey();
        await withTransaction(config.storeName, 'readwrite', store => {
            store.delete(url);
        });
        console.info("已删除当前页面数据", { url });
    }

    /**
     * 删除所有页面的滚动位置记录
     */
    async function deleteAllData() {
        await withTransaction(config.storeName, 'readwrite', store => {
            store.clear();
        });
        console.info("已清空所有数据");
    }

    // 滚动防抖逻辑
    let lastPosition = 0;
    let debounceTimer = null;

    function handleScroll() {
        const currentPosition = window.scrollY;
        if (Math.abs(currentPosition - lastPosition) > config.scrollThreshold) {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(() => {
                saveScrollPosition();
                lastPosition = currentPosition;
            }, config.debounceTime);
        }
    }

    let isInitialized = false;

    function initializeScrollTracking() {
        if (isInitialized) return;
        document.addEventListener("DOMContentLoaded", restoreScrollPosition);
        window.addEventListener('scroll', handleScroll);
        isInitialized = true;
    }

    function stopScrollTracking() {
        window.removeEventListener('scroll', handleScroll);
        isInitialized = false;
    }

    // 初始化模块
    function init() {
        if (!window.indexedDB) {
            console.warn("该功能需要浏览器支持 IndexedDB");
            return;
        }

        window.scrollRestorer = {
            initializeScrollTracking,
            stopScrollTracking,
            saveScrollPosition,
            restoreScrollPosition,
            clearExpiredEntries,
            deleteCurrentPageData,
            deleteAllData,
        };

        scrollRestorer.initializeScrollTracking();
        scrollRestorer.clearExpiredEntries().catch(console.error); // 自动清理一次
    }

    // 页面加载完成后初始化
    if (document.readyState === 'complete') {
        init();
    } else {
        window.addEventListener('load', init);
    }

})();