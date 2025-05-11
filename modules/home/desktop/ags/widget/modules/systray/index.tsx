import { Gtk, Gdk } from "astal/gtk3";
import { isPrimaryClick, isSecondaryClick, isMiddleClick } from "../../../lib/utils";
import { Variable, Gio, bind } from "astal"
import Tray from "gi://AstalTray"

const createMenu = (menuModel: Gio.MenuModel, actionGroup: Gio.ActionGroup | null): Gtk.Menu => {
    const menu = Gtk.Menu.new_from_model(menuModel);
    menu.insert_action_group('dbusmenu', actionGroup);

    return menu;
};
const MenuCustomIcon = ({ iconLabel, iconColor, item }: MenuCustomIconProps): JSX.Element => {
    return (
        <label
            className={'systray-icon txt-icon'}
            label={iconLabel}
            css={iconColor ? `color: ${iconColor}` : ''}
            tooltipMarkup={bind(item, 'tooltipMarkup')}
        />
    );
};

const MenuDefaultIcon = ({ item }: MenuEntryProps): JSX.Element => {
    return <icon className={'systray-icon'} gIcon={bind(item, 'gicon')} tooltipMarkup={bind(item, 'tooltipMarkup')} />;
};

const MenuEntry = ({ item, child }: MenuEntryProps): JSX.Element => {
    let menu: Gtk.Menu;

    const entryBinding = Variable.derive(
        [bind(item, 'menuModel'), bind(item, 'actionGroup')],
        (menuModel, actionGroup) => {
            if (!menuModel) {
                return console.error(`Menu Model not found for ${item.id}`);
            }
            if (!actionGroup) {
                return console.error(`Action Group not found for ${item.id}`);
            }

            menu = createMenu(menuModel, actionGroup);
        },
    );

    return (
        <button
            cursor={'pointer'}
            onClick={(self, event) => {
                if (isPrimaryClick(event)) {
                    item.activate(0, 0);
                }

                if (isSecondaryClick(event)) {
                    menu?.popup_at_widget(self, Gdk.Gravity.NORTH, Gdk.Gravity.SOUTH, null);
                }

                if (isMiddleClick(event)) {
                    // Notify({ summary: 'App Name', body: item.id });
                }
            }}
            onDestroy={() => {
                menu?.destroy();
                entryBinding.drop();
            }}
        >
            {child}
        </button>
    );
};


const SysTray = () => {
    const tray = Tray.get_default()

    const menuItems = Variable.derive(
        [bind(tray, 'items')],
        (items) => {
            return items.map(item => {
                // TODO: When electron apps stop all reporting chrome_status_icon_1 this might be more useful
                const customIcons : Dictionary<CustomTrayIcon> = {
                    "spotify": {
                        icon: "󰓇",
                        color: "#1ED760"
                    },
                    "steam": {
                        icon: "",
                        color: "#fff"
                    },
                    "discord": {
                        icon: "",
                        color: "#5466F4"
                    },
                    "teams": {
                        icon: "󰊻",
                        color: "#7C81ED"
                    }
                };
                const matchedCustomIcon = Object.keys(customIcons).find((iconRegex) => item.id.match(iconRegex));
                if (matchedCustomIcon !== undefined) {
                    const iconLabel = customIcons[matchedCustomIcon].icon || '󰠫';
                    const iconColor = customIcons[matchedCustomIcon].color;

                    return (
                        <MenuEntry item={item}>
                            <MenuCustomIcon iconLabel={iconLabel} iconColor={iconColor} item={item} />
                        </MenuEntry>
                    );
                }
                return (
                    <MenuEntry item={item}>
                        <MenuDefaultIcon item={item} />
                    </MenuEntry>
                );
            });
        }
    );

    return <box className="SysTray" onDestroy={() => menuItems.drop()}>
        {menuItems()}
    </box>
}

interface MenuCustomIconProps {
    iconLabel: string;
    iconColor: string;
    item: Tray.TrayItem;
}

interface MenuEntryProps {
    item: Tray.TrayItem;
    child?: JSX.Element;
}

interface Dictionary<T> {
    [key: string]: T;
}

interface CustomTrayIcon{
    icon: string;
    color: string;
}

export { SysTray };
