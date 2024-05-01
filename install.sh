#!/bin/sh

echo "This will simply add \"Shutdown\" button to your system menu. Do you want to continue? (y/n)"
read answer
case $answer in
    [yY]* )

        ;;
    [nN]* )
        echo "Installation cancelled."
        exit
        ;;
    * )
        echo "Invalid input. Please answer with y or n."
        exit
        ;;
esac

APP_DIR="/usr/lib/lua/luci/controller/system"

mkdir -p "$APP_DIR"

cat > "$APP_DIR/shutdown.lua" <<EOF
module("luci.controller.system.shutdown", package.seeall)

function index()
    entry({"admin", "system", "shutdown"}, call("action_shutdown"), _("Shutdown"), 90)
end

function action_shutdown()
    luci.template.render("system/shutdown")
end
EOF

mkdir -p "$APP_DIR/view"

cat > "$APP_DIR/view/shutdown.htm" <<EOF
<form action="shutdown" method="post">
    <button type="submit">Shutdown</button>
</form>
EOF

cat > "$APP_DIR/view/shutdown.lua" <<EOF
function action_shutdown()
    -- Safe shutdown command
    os.execute("poweroff")
end
EOF

chmod +x "$APP_DIR/view/shutdown.lua"

echo "Shutdown button added successfully."

rm -- "$0"
