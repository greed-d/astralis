pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    property bool bs: false
    property int viewYear: 0
    property int viewMonth: 0   // 0-based
    readonly property var bsMonths: ["Baisakh", "Jestha", "Ashadh", "Shrawan", "Bhadra", "Ashwin", "Kartik", "Mangsir", "Poush", "Magh", "Falgun", "Chaitra"]
    readonly property var adMonths: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    // year -> 12 month lengths. Fill from a verified dataset (e.g. nepali-date-converter data), 2000..2090.
    readonly property var bsData: ({
            2000: [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31]
        // ...
        })
    readonly property int bsBase: 2000
    readonly property double bsEpochMs: Date.UTC(1943, 3, 14)
    readonly property double dayMs: 86400000

    function bsToAd(y, m, d) {            // m 0-based -> UTC ms
        let days = 0;
        for (let yy = bsBase; yy < y; yy++)
            days += bsData[yy].reduce((a, b) => a + b, 0);
        for (let mm = 0; mm < m; mm++)
            days += bsData[y][mm];
        return bsEpochMs + (days + d - 1) * dayMs;
    }

    function adToBs(ms) {                 // UTC ms -> {y, m, d}
        let days = Math.round((ms - bsEpochMs) / dayMs);
        let y = bsBase;
        while (bsData[y] && days >= bsData[y].reduce((a, b) => a + b, 0))
            days -= bsData[y++].reduce((a, b) => a + b, 0);
        let m = 0;
        while (days >= bsData[y][m])
            days -= bsData[y][m++];
        return {
            y: y,
            m: m,
            d: days + 1
        };
    }

    function todayMs() {
        const n = new Date();
        return Date.UTC(n.getFullYear(), n.getMonth(), n.getDate());
    }

    function goToday() {
        const t = todayMs();
        if (bs) {
            const b = adToBs(t);
            viewYear = b.y;
            viewMonth = b.m;
        } else {
            const d = new Date(t);
            viewYear = d.getUTCFullYear();
            viewMonth = d.getUTCMonth();
        }
    }

    function toggle() {
        // keep the same visible month, re-express in the other system
        let firstMs = bs ? bsToAd(viewYear, viewMonth, 1) : Date.UTC(viewYear, viewMonth, 1);
        bs = !bs;
        if (bs) {
            const b = adToBs(firstMs);
            viewYear = b.y;
            viewMonth = b.m;
        } else {
            const d = new Date(firstMs);
            viewYear = d.getUTCFullYear();
            viewMonth = d.getUTCMonth();
        }
    }

    function step(delta) {
        let m = viewMonth + delta, y = viewYear;
        if (m < 0) {
            m = 11;
            y--;
        } else if (m > 11) {
            m = 0;
            y++;
        }
        if (bs && !bsData[y])
            // out of table range
            return;
        viewMonth = m;
        viewYear = y;
    }

    // 42 cells: {day, alt, inMonth, today}
    function cells() {
        const out = [], today = todayMs();
        const firstMs = bs ? bsToAd(viewYear, viewMonth, 1) : Date.UTC(viewYear, viewMonth, 1);
        const len = bs ? bsData[viewYear][viewMonth] : new Date(Date.UTC(viewYear, viewMonth + 1, 0)).getUTCDate();
        const offset = new Date(firstMs).getUTCDay();   // Sunday-first
        for (let i = 0; i < 42; i++) {
            const ms = firstMs + (i - offset) * dayMs;
            const inMonth = i >= offset && i < offset + len;
            let day, alt;
            if (bs) {
                day = adToBs(ms)?.d ?? 0;                // guard if out of range
                alt = new Date(ms).getUTCDate();
            } else {
                day = new Date(ms).getUTCDate();
                alt = adToBs(ms).d;
            }
            out.push({
                day,
                alt,
                inMonth,
                today: ms === today
            });
        }
        return out;
    }

    Component.onCompleted: goToday()
}
