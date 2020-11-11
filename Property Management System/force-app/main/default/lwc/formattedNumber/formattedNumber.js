import { api } from 'lwc';
import Element from 'c/element';
export default class FormattedNumber extends Element { 
    @api value;
    @api formatStyle;
    @api currencyCode;
    @api currencyDisplayAs;
    @api minimumIntegerDigits;
    @api minimumFractionDigits;
    @api maximumFractionDigits;
    @api minimumSignificantDigits;
    @api maximumSignificantDigits;
}