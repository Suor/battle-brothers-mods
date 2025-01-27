::Hooks.registerJS("ui/mods/bro_studio/slider_setting.js");

::BroStudio.SliderSetting <- class extends ::MSU.Class.RangeSetting {
    Values = null;
    Labels = null;
    static Type = "BroStudio_Slider";

    constructor(_id, _value, _values, _labels = null, _name = null, _description = null) {
        if (_values.find(_value) == null) {
            ::logError("SliderSetting: _value must be an element in _values");
            throw ::MSU.Exception.KeyNotFound(_value);
        }
        if (_labels == null) {
            _labels = _values;
        } else if (typeof _labels != "array") {
            if (_description != null) throw "SliderSetting: too many arguments";
            _description = _name;
            _name = _labels;
            _labels = _values;
        } else if (_labels.len() != _values.len()) {
            throw "SliderSetting: values and labels lens must match";
        }
        ::std.Debug.log("slider", {
            id = _id, value = _value, values = _values, labels = _labels,
            name = _name, description = _description
        })
        base.constructor(_id, _value, 0, _values.len() - 1, 1, _name, _description);
        this.Values = _values;
        this.Labels = _labels;
    }

    function getUIData(_flags = []) {
        return ::std.Table.merge(
            base.getUIData(_flags), {values = this.Values, labels = this.Labels})
    }

    function tostring() {
        return base.tostring() + " | Values: " + ::std.Dumper.pp(this.Values)
            + " | Labels: " + ::std.Dumper.pp(this.Labels);
    }

    function flagDeserialize(_in) {
        base.flagDeserialize(_in);
        if (this.Values.find(this.Value) == null) {
            ::logError("Value \'" + this.Value + "\' not contained in array for setting "
                 + this.getID() + " in mod " + this.getMod().getID());
            this.reset();
        }
    }
}
