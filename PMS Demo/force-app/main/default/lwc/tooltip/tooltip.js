import { api } from 'lwc';
import Element from 'c/element';
export default class Tooltip extends Element {
    @api content;
    @api variant;
    @api iconName;
}