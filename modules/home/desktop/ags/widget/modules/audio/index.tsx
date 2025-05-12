import { Variable, bind } from "astal"
import Wp from "gi://AstalWp?version=0.1"

const Audio = () => {
    const speaker = Wp.get_default()?.audio.defaultSpeaker!;

    const volume = Variable.derive(
        [bind(speaker, "volume")],
        (vol) => `${(vol*100).toFixed(0)}%`
    );

    // TODO: Do something when clicking :)
    return <button cursor={'pointer'} onClick={(self, event) => {}} className="module-button">
        <box className="Audio BarModule">
            <icon className="module-icon" icon={bind(speaker, "volumeIcon")}/>
            <label className="module-label" onDestroy={() => volume.drop()} label={bind(volume)}/>
        </box>
    </button>
}

export { Audio }
