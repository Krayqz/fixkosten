// keeps the app itself on the phone so it also opens without internet
const CACHE = "fixkosten-v1";
const SHELL = ["./", "index.html", "config.js", "vendor/supabase.js", "manifest.webmanifest", "icon.svg", "icon-512.png", "apple-touch-icon.png"];

self.addEventListener("install", e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL)).then(() => self.skipWaiting()));
});
self.addEventListener("activate", e => {
  e.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener("fetch", e => {
  const url = new URL(e.request.url);
  // only our own files; logins and data go straight to Supabase, videos are only loaded when online
  if (e.request.method !== "GET" || url.origin !== location.origin || url.pathname.includes("/videos/")) return;
  // newest version first, the saved copy only when there is no connection
  e.respondWith(fetch(e.request).then(res => {
    if (res.ok) { const copy = res.clone(); caches.open(CACHE).then(c => c.put(e.request, copy)); }
    return res;
  }).catch(() => caches.match(e.request, { ignoreSearch: true }).then(hit => hit || caches.match("index.html"))));
});
