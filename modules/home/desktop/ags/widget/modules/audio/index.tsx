import { Variable, bind } from "astal"
import Wp from "gi://AstalWp?version=0.1"

const Audio = () => {
    const speaker = Wp.get_default()?.audio.defaultSpeaker!;

    const volume = Variable.derive(
        [bind(speaker, "volume")],
        (vol) => `${(vol*100).toFixed(0)}%`
    );

    return <box className="Audio BarModule">
        <icon icon={bind(speaker, "volumeIcon")}/>
        <label onDestroy={() => volume.drop()} label={bind(volume)}/>
    </box>
}

export { Audio }
