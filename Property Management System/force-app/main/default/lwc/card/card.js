import { api } from 'lwc';
import Element from 'c/element';

export default class Card extends Element {
    @api title;
    @api content;
    @api variant;
    @api iconName;
    @api repeaterIndex;
    
}