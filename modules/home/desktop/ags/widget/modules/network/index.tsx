import { Variable, bind } from "astal"
import Network from "gi://AstalNetwork"

const Networking = () => {
    const network = Network.get_default()
    const wifi = bind(network, "wifi")
    const wired = bind(network, "wired")

    const wiredIcon: Variable<string> = Variable('');
    const wirelessIcon: Variable<string> = Variable('');
    const ssidLabel: Variable<string> = Variable('');

    if (network.wifi) {
        Variable.derive([bind(network.wifi, 'iconName')], (icon) => {
            wirelessIcon.set(icon);
        });

        Variable.derive([bind(network.wifi, 'ssid')], (ssid) => {
            ssidLabel.set(ssid);
        });
    }

    if (network.wired) {
        Variable.derive([bind(network.wired, 'iconName')], (icon) => {
            wiredIcon.set(icon);
        });
    }

    const iconBinding = Variable.derive(
        [bind(network, "primary"), bind(wiredIcon), bind(wirelessIcon)],
        (primary, wiredIcon, wirelessIcon) => {
            return primary === Network.Primary.WIRED ? wiredIcon : wirelessIcon;
        }
    );

    const labelBinding = Variable.derive(
        [bind(network, "primary"), bind(ssidLabel)],
        (primary, ssid) => {
            return primary === Network.Primary.WIRED ? "wired" : ssid;
        }
    );

    return <box className="Networking BarModule" visible={true}>
        <icon onDestroy={() => iconBinding.drop()} icon={iconBinding()}/>
        <label onDestroy={() => labelBinding.drop()} label={bind(labelBinding)} />
    </box>
}

export { Networking };
