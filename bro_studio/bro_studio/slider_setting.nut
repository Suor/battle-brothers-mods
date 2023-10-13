::mods_registerJS("bro_studio/slider_setting.js");

::BroStudio.SliderSetting <- class extends ::MSU.Class.RangeSetting {
    Array = null;
    static Type = "BroStudio_Slider";

    constructor(_id, _value, _array, _name = null, _description = null) {
        if (_array.find(_value) == null) {
            ::logError("_value must be an element in _array");
            throw ::MSU.Exception.KeyNotFound(_value);
        }
        base.constructor(_id, _value, 0, _array.len() - 1, 1, _name, _description);
        this.Array = _array;
    }

    function getUIData(_flags = []) {
        return ::std.Table.merge(base.getUIData(_flags), {array = this.Array})
    }

    function tostring() {
        return base.tostring() + " | Array: " + ::std.Dumper.pp(this.Array);
    }

    function flagDeserialize(_in) {
        base.flagDeserialize(_in);
        if (this.Array.find(this.Value) == null) {
            ::logError("Value \'" + this.Value + "\' not contained in array for setting "
                 + this.getID() + " in mod " + this.getMod().getID());
            this.reset();
        }
    }
}
