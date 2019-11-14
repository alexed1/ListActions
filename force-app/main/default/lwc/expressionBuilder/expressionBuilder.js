import {LightningElement, track, api, wire} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
//import conditionLogicHelpText from '@salesforce/label/c.ConditionLogicHelpText';
import assembleFormulaString from '@salesforce/apex/ExpressionBuilder.assembleFormulaString';
import disassemblyFormulaString from '@salesforce/apex/ExpressionBuilder.disassemblyFormulaString';
import describeSObjects from '@salesforce/apex/SearchUtils.describeSObjects';

export default class expressionBuilder extends LightningElement {

    @api expressions;
    @api addButtonLabel = 'Add Condition';
    @api localVariables;
    @api systemVariables;
    @api availableRHSMergeFields;

    @track objectName;
    @track expressionLines = [];
    @track customLogic = '';
    @track logicType = 'AND';
    @track convertedExpression;
    @track contextFields = [];
    @track contextTypes = [];
    @track isLoading = true;

    @api
    get value() {
        return this.convertedExpression;
    }

    set value(value) {
        this.convertedExpression = value;
    }

    @api
    get contextRecordObjectName() {
        return this._objectName;
    }

    set contextRecordObjectName(value) {
        this._objectName = value;
        if (!this.contextTypes || this.contextTypes.length === 0) {
            this.contextTypes = [value];
        }
    }

    @api //f.e. 'User,Organization,Profile'
    get supportedContextTypes() {
        return this.contextTypes.filter(curObject => curObject !== this._objectName).join(',');
    }

    set supportedContextTypes(value) {
        this.contextTypes = [...[this._objectName], ...this.splitValues(value)];
    }

    @wire(describeSObjects, {types: '$contextTypes'})
    _describeSObjects(result) {
        if (result.error) {
            console.log(result.error.body);
        } else if (result.data) {
            this.contextTypes.forEach(objType => {
                let newContextFields = result.data[objType].map(curField => {
                    return {
                        ...curField, ...{
                            label: objType + ': ' + curField.label,
                            value: '$' + curField.type + '.' + curField.value
                        }
                    }
                });

                if (this.contextFields && this.contextFields.length > 0) {
                    this.contextFields = this.contextFields.concat(newContextFields);
                } else {
                    this.contextFields = newContextFields;
                }
            });

            if (this.contextFields && this.contextFields.length > 0) {
                this.doDisassemblyFormulaString();
            }
        }
    }

    lastExpressionIndex = 0;
    logicTypes = [
        {value: 'AND', label: 'All Conditions Are Met'},
        {value: 'OR', label: 'Any Condition Is Met'},
        {value: 'CUSTOM', label: 'Custom Condition Logic Is Met'}
    ];
    conditionLogicHelpText = 'placeholder for conditionLogicHelpTest' //conditionLogicHelpText;

    doDisassemblyFormulaString() {
        let expressionsToDisassemble = this.convertedExpression ? this.convertedExpression : this.expressions;
        disassemblyFormulaString({expression: expressionsToDisassemble}).then(result => {
            if (result.logicType !== undefined) {
                this.logicType = result.logicType;
            }
            if (result.customLogic !== undefined) {
                this.customLogic = result.customLogic;
            }
            if (result.expressionLines !== undefined) {
                let expressionLines = [];
                result.expressionLines.forEach((line, index) => {
                    let fieldData = this.contextFields.find(curField => curField.value === line.fieldName);
                    expressionLines.push({
                        ...this.generateNewExpression(), ...{
                            fieldName: line.fieldName,
                            id: index,
                            objectType: line.objectType,
                            operator: line.operator,
                            parameter: line.parameter,
                            dataType: fieldData ? fieldData.dataType : null
                        }
                    });
                    this.lastExpressionIndex = index + 1
                });
                this.expressionLines = expressionLines;
            }
            this.isLoading = false;
        })
    }

    generateNewExpression() {
        return {
            id: this.lastExpressionIndex++,
            objectType: this.contextRecordObjectName,
            localVariables: this.localVariables !== undefined ? JSON.parse(this.localVariables) : [],
            systemVariables: this.systemVariables !== undefined ? JSON.parse(this.systemVariables) : [],
            availableRHSMergeFields: this.availableRHSMergeFields !== undefined ? JSON.parse(this.availableRHSMergeFields) : [],
            parameter: ''
        };
    }

    handleAddExpression() {
        this.expressionLines.push(this.generateNewExpression());
    }

    get showCustomLogicInput() {
        return this.logicType === 'CUSTOM';
    }

    handleCustomLogicChange(event) {
        this.customLogic = event.detail.value;
        this.assembleFormula();
    }

    handleWhenToExecuteChange(event) {
        this.logicType = event.detail.value;
        this.assembleFormula();
    }

    handleExpressionChange(event) {
        let expressionToModify = this.expressionLines.find(curExp => curExp.id === event.detail.id);

        for (let detailKey in event.detail) {
            if (Object.prototype.hasOwnProperty.call(event.detail, detailKey)) {
                expressionToModify[detailKey] = event.detail[detailKey];
            }
        }
        if (event.detail.isInit !== true && this.isExpressionValid(expressionToModify)) {
            this.assembleFormula();
        }
    }

    isExpressionValid(expression) {
        return !!(expression.fieldName && expression.operator && expression.parameter);
    }

    handleRemoveExpression(event) {
        this.expressionLines = this.expressionLines.filter(curExp => curExp.id !== event.detail);
        this.assembleFormula();
    }

    assembleFormula() {
        if ((this.logicType === 'CUSTOM' && this.customLogic.length > 0) || this.logicType !== 'CUSTOM') {
            assembleFormulaString({
                customLogic: this.customLogic.toUpperCase(),
                logicType: this.logicType,
                expressionLines: JSON.stringify(this.expressionLines)
            }).then(result => {
                this.convertedExpression = result
            })
        } else {
            this.convertedExpression = ''
        }

        const valueChangeEvent = new FlowAttributeChangeEvent('value', this.convertedExpression);
        this.dispatchEvent(valueChangeEvent);

    }

    get disabledAddButton() {
        return this.expressionLines.length > 9;
    }

    splitValues(originalString) {
        return originalString ? originalString.replace(/ /g, '').split(',') : [];
    }
}