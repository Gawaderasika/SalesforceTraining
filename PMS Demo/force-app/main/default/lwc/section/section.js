/* eslint-disable no-console */
import { api } from 'lwc';
import Element from "c/element";

export default class Section extends Element {
    @api sectionHeader = 'Section Header';
    @api headerStyle = '';
    @api repeaterIndex;

}