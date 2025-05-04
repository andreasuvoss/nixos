import { Variable, bind } from "astal"
import AstalBattery from "gi://AstalBattery?version=0.1"

const Battery = () => {
    const battery = AstalBattery.get_default();

    const isVisible = Variable.derive(
        [bind(battery, "state")],
        (state) => state != AstalBattery.State.UNKNOWN
    );

    // Not sure if this is the correct way of doing this, but it does not throw errors and it works
    if (!isVisible.get()){
        return;
    }

    const percentage = Variable.derive(
        [bind(battery, "percentage")],
        (percent) => `${percent}%`
    );

    return <box onDestroy={() => isVisible.drop()} className="Battery BarModule">
        <icon icon={bind(battery, "iconName")} />
        <label onDestroy={() => percentage.drop()} label={bind(percentage)} />
    </box>
}

export { Battery }
