import {  api } from 'lwc';
import Element from 'c/element';

export default class AccordionSection extends Element {
    @api name;
    @api title;
    @api label;
    @api repeaterIndex;
}