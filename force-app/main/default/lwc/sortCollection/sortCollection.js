import {LightningElement, track, api, wire} from 'lwc';
import describeSObjects from '@salesforce/apex/SearchUtils.describeSObjects';

export default class sortCollection extends LightningElement {

    @track objectName;
    @track contextTypes = [];
    @track fields = [];
    @track lines = [{position: 0, field: 'Name', direction: 'ASC'}]; // if default values is removed, change lastLinePosition to 0
    lastLinePosition = 1;

    // defaultLine = {position: 0, field: 'Name', direction: 'ASC'};

    @wire(describeSObjects, {types: '$contextTypes'})
    _describeSObjects(result) {
        if (result.error) {
            console.log(result.error.body);
        } else if (result.data) {
            let fields = JSON.parse(JSON.stringify(result.data[this.objectName]));
            this.fields = fields.sort((a, b) => (a.label > b.label) ? 1 : ((b.label > a.label) ? -1 : 0));
        }
    }

    @api
    get sortKeys() {
        return JSON.stringify({
            sortKeys: this.lines.map(curLine => {
                return {field: curLine.field, direction: curLine.direction}
            })
        });
    }

    set sortKeys(value) {
        this.lastLinePosition = 0;
        if (value) {
            let val = JSON.parse(value);
            if (val.sortKeys && val.sortKeys.length) {
                this.lines = val.sortKeys.map((curKey, index) => {
                    this.lastLinePosition = index;
                    return {...curKey, ...{position: index}}
                });
            }
        }
    }

    handleDataChanged(event) {
        let curLine = this.lines.find(curLine => curLine.position === event.detail.position);
        if (curLine) {
            curLine.field = event.detail.field;
            curLine.direction = event.detail.direction;
        }
    }

    handleAddLine(event) {
        this.lines.push({position: this.lastLinePosition++});
    }

    handleReorder(event) {
        let originalIndex = this.lines.findIndex(curItem => curItem.position === event.detail.position);
        let newIndex = originalIndex + event.detail.direction;
        if (newIndex >= 0 && newIndex < this.lines.length) {
            this.lines = this.move(originalIndex, newIndex, ...this.lines);
        }
    }

    @api
    get contextRecordObjectName() {
        return this.objectName;
    }

    set contextRecordObjectName(value) {
        this.objectName = value;
        if (!this.contextTypes || this.contextTypes.length === 0) {
            this.contextTypes = [value];
        }
    }

    move(from, to, ...a) {
        from === to ? a : (a.splice(to, 0, ...a.splice(from, 1)), a);
        return a;
    }

}