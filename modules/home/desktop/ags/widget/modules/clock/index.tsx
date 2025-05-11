import { Variable } from "astal";
import GLib from "gi://GLib?version=2.0";

const Time = ({ format = "%H:%M" }) => {
    const time = Variable<string>("").poll(1000, () =>
        GLib.DateTime.new_now_local().format(format)!)
    const ClockIcon = (): JSX.Element => <label className={'module-icon-txt'} label="󰸗" />;

    return <box className="Time BarModule" visible={true} onDestroy={() => time.drop()}>
        <ClockIcon/>
        <label className="module-label" label={time()} />
    </box>
    return <label
        className="Time"
        onDestroy={() => time.drop()}
        label={time()}
    />
}

export { Time };
