#!/usr/bin/python3

import locale
import logging
import os
import shutil
import subprocess
from gettext import gettext

from gi import require_version
from gi.repository import GObject, Nautilus

require_version("Gtk", "4.0")
require_version("Nautilus", "4.0")

FLATPAK_ID = "com.visualstudio.code"

if os.environ.get("NAUTILUS_VSCODE_DEBUG", "False") == "True":
    logging.basicConfig(level=logging.DEBUG)


class VSCodeNautilus(GObject.GObject, Nautilus.MenuProvider):
    def __init__(self):
        super().__init__()
        self.is_select = False
        pass

    def get_file_items(self, files: list[Nautilus.FileInfo]):
        """Return to menu when click on any file/folder"""
        if not self.only_one_file_info(files):
            return []

        menu = []
        fileInfo = files[0]
        self.is_select = False

        if fileInfo.is_directory():
            self.is_select = True
            dir_path = self.get_abs_path(fileInfo)

            logging.debug("Selecting a directory!!")
            logging.debug(f"Create a menu item for entry {dir_path}")

            menu_item = self._create_nautilus_item(dir_path)
            menu.append(menu_item)

        return menu

    def get_background_items(self, directory):
        """Returns the menu items to display when no file/folder is selected
        (i.e. when right-clicking the background)."""

        # Some concurrency problem fix. When you select a directory, and right
        # mouse, nautilus will call this once the moments you focus the menu.
        # This code to ignore that time.

        if self.is_select:
            self.is_select = False
            return []

        menu = []

        if directory.is_directory():
            dir_path = self.get_abs_path(directory)

            logging.debug("Not thing is selected. Launch from backgrounds!")
            logging.debug(f"Create a menu item for entry {dir_path}")

            menu_item = self._create_nautilus_item(dir_path)
            menu.append(menu_item)

        return menu

    def is_native(self):
        if shutil.which("code") == "/usr/bin/code":
            return "code"

        if shutil.which("code-insiders") == "/usr/bin/code-insiders":
            return "code-insiders"

    def get_abs_path(self, file_info: Nautilus.FileInfo):
        path = file_info.get_location().get_path()
        return path

    def only_one_file_info(self, files: list[Nautilus.FileInfo]):
        return len(files) == 1

    def _vscode_run(self, _, path: str):
        """'Open with Black Box 's menu item callback."""
        logging.debug(f"Open with Black Box {path=}")
        args = None

        if self.is_native() == "code":
            args = ["code", path]

        elif self.is_native() == "code-insiders":
            args = ["code-insiders", path]

        else:
            args = ["/usr/bin/flatpak", "run", FLATPAK_ID, "-w", path]

        subprocess.Popen(args, cwd=path)

    def _create_nautilus_item(self, dir_path: str) -> Nautilus.MenuItem:
        """Creates the 'Open In Visual Studio Code' menu item."""

        match locale.getlocale()[0].split("_")[0]:
            case "pt":
                text_label = "Abrir no Visual Studio Code"
            case _:
                text_label = "Open In Visual Studio Code"

        match locale.getlocale()[0].split("_")[0]:
            case "pt":
                text_tip = "Abrir esta pasta/arquivo no Visual Studio Code"
            case _:
                text_tip = "Open this folder/file in Visual Studio Code"

        item = Nautilus.MenuItem(
            name="BlackBoxNautilus::open_in_vscode",
            label=gettext(text_label),
            tip=gettext(text_tip),
        )

        item.connect("activate", self._vscode_run, dir_path)
        logging.debug(f"Connectted trigger to menu item ({dir_path=})")

        return item
