import { Astal, Gdk, Gtk } from 'astal/gtk3';
// import AstalNotifd from 'gi://AstalNotifd?version=0.1';
//
// const notifdService = AstalNotifd.get_default();

export const isPrimaryClick = (event: Astal.ClickEvent): boolean => event.button === Gdk.BUTTON_PRIMARY;
export const isSecondaryClick = (event: Astal.ClickEvent): boolean => event.button === Gdk.BUTTON_SECONDARY;
export const isMiddleClick = (event: Astal.ClickEvent): boolean => event.button === Gdk.BUTTON_MIDDLE;
// export function Notify(notifPayload: NotificationArgs): void {
//     // This line does nothing useful at runtime, but when bundling, it
//     // ensures that notifdService has been instantiated and, as such,
//     // that the notification daemon is active and the notification
//     // will be handled
//     notifdService; // eslint-disable-line @typescript-eslint/no-unused-expressions
//
//     let command = 'notify-send';
//     command += ` "${notifPayload.summary} "`;
//     if (notifPayload.body) command += ` "${notifPayload.body}" `;
//     if (notifPayload.appName) command += ` -a "${notifPayload.appName}"`;
//     if (notifPayload.iconName) command += ` -i "${notifPayload.iconName}"`;
//     if (notifPayload.urgency) command += ` -u "${notifPayload.urgency}"`;
//     if (notifPayload.timeout !== undefined) command += ` -t ${notifPayload.timeout}`;
//     if (notifPayload.category) command += ` -c "${notifPayload.category}"`;
//     if (notifPayload.transient) command += ` -e`;
//     if (notifPayload.id !== undefined) command += ` -r ${notifPayload.id}`;
//
//     execAsync(command)
//         .then()
//         .catch((err) => {
//             console.error(`Failed to send notification: ${err.message}`);
//         });
// }
