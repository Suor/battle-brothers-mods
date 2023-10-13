function BroStudio_SliderSetting(_mod, _page, _setting, _parentDiv) {
    _setting.value = _setting.array.indexOf(_setting.value);
    RangeSetting.call(this, _mod, _page, _setting, _parentDiv);
    _setting.value = _setting.array[_setting.value];

    // Only need to set it once
    this.slider.attr({min: this.data.min, max: this.data.max, step: this.data.step});

    this.layout.off("change");
    this.layout.on("change", this.onChange.bind(this));
    this.updateValue();
}
BroStudio_SliderSetting.prototype.__proto__ = RangeSetting.prototype;

BroStudio_SliderSetting.prototype.updateValue = function () {
    this.slider.val(this.data.array.indexOf(this.data.value));
    this.label.text('' + this.data.value);
}

BroStudio_SliderSetting.prototype.onChange = function () {
    this.data.value = this.data.array[parseInt(this.slider.val())];
    this.label.text('' + this.data.value);
}
