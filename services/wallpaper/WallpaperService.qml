pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var wallpapers: []

    function load(manifestPath) {
        listFile.path = manifestPath;
        root.wallpapers = parseManifest(listFile.text());
    }

    function parseManifest(content) {
        return content.split("\n").map(function (line) {
            return line.trim();
        }).filter(function (line) {
            return line.length > 0;
        }).map(function (line) {
            return {
                path: line
            };
        });
    }

    FileView {
        id: listFile
        blockLoading: true
        watchChanges: true
        onFileChanged: {
            reload();
            root.wallpapers = root.parseManifest(text());
            //console.log(root.parseManifest());
        }
    }
}
