if (self.CavalryLogger) { CavalryLogger.start_js(["ARXwa"]); }

__d("InputLabel.react",["cx","invariant","HelpLink.react","React","joinClasses","uniqueID"],(function(a,b,c,d,e,f,g,h){"use strict";__p&&__p();var i;c=b("React").PropTypes;i=babelHelpers.inherits(a,b("React").Component);i&&i.prototype;a.prototype.render=function(){__p&&__p();var a,c,d=this.props.children;Array.isArray(d)?(this.props.children.length===2||h(0,691),a=d[0],c=d[1]):a=d;d=a.type==="input";a=b("React").cloneElement(a,{className:b("joinClasses")(a.props.className,"uiInputLabelInput"+(d&&a.props.type==="radio"?" uiInputLabelRadio":"")+(d&&a.props.type==="checkbox"?" uiInputLabelCheckbox":"")),id:a.props.id||b("uniqueID")()});var e,f=this.props,g=f.label,i=f.helpText;f=babelHelpers.objectWithoutProperties(f,["label","helpText"]);if(c)e=b("React").cloneElement(c,{className:b("joinClasses")(this.props.labelClassName,this.props.flipped?"uiInputLabelLabelFlipped":"uiInputLabelLabel"),htmlFor:a.props.id});else{i=i?b("React").createElement(b("HelpLink.react"),{tooltip:i}):null;e=b("React").createElement("label",{className:b("joinClasses")(this.props.labelClassName,this.props.flipped?"uiInputLabelLabelFlipped":"uiInputLabelLabel"),htmlFor:a.props.id},g,i)}g="uiInputLabel clearfix"+(this.props.display==="inline"?" inlineBlock":"")+(d?" uiInputLabelLegacy":"");return b("React").createElement("div",babelHelpers["extends"]({},f,{className:b("joinClasses")(this.props.className,g)}),this.props.flipped?e:a,this.props.flipped?a:e)};function a(){i.apply(this,arguments)}a.propTypes={display:c.oneOf(["block","inline"])};a.defaultProps={display:"block"};e.exports=a}),null);
__d("XUICheckboxInput.react",["cx","AbstractCheckboxInput.react","React","joinClasses"],(function(a,b,c,d,e,f,g){__p&&__p();var h;h=babelHelpers.inherits(a,b("React").Component);h&&h.prototype;a.prototype.render=function(){"use strict";return b("React").createElement(b("AbstractCheckboxInput.react"),babelHelpers["extends"]({},this.props,{ref:function(a){return this.$1=a}.bind(this),className:b("joinClasses")(this.props.className,"_55sg")}),void 0)};a.prototype.focusInput=function(){"use strict";this.$1&&this.$1.focusInput()};a.prototype.blurInput=function(){"use strict";this.$1&&this.$1.blurInput()};function a(){"use strict";h.apply(this,arguments)}e.exports=a}),null);