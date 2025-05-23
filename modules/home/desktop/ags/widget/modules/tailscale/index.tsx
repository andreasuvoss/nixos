import { Variable } from "astal"

const Tailscale = () => {

    function findObjectById(obj: any, targetId: string): any {
        if (typeof obj !== 'object' || obj === null) return null;

        // Check if current object has the matching ID
        if (obj.ID === targetId) {
            return obj;
        }

        // Recursively check properties
        for (const key in obj) {
            if (typeof obj[key] === 'object') {
                const found = findObjectById(obj[key], targetId);
                if (found) return found;
            }
        }

        return null;
    }

    const tailscaleStatus = Variable("").poll(10000, ["tailscale", "status", "--peers", "--json"], (out: string, prev: string) => {
        try {
            const data = JSON.parse(out);
            if (!data.Self.Online) return "off";

            if (data.ExitNodeStatus) {
                const peer = findObjectById(data.Peer, data.ExitNodeStatus.ID);
                return `${peer.HostName}`;
            }
            return "on";
        } catch (error) {
            return "Error";
        }
    });
    // TODO: The image should not be hardcoded like below - and also it uses a lot of CPU for some reason...
    // <icon icon="/home/andreasvoss/repos/nixos/modules/home/desktop/ags/widget/tailscale.svg" />
    return <box className="Tailscale BarModule">
        <icon className="module-icon" icon="tailscale-symbolic" />
        <label className="module-label" onDestroy={() => tailscaleStatus.drop()} label={tailscaleStatus()} />
    </box>
}

export { Tailscale };
