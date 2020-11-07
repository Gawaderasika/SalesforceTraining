import { api } from 'lwc';
import Element from 'c/element';

export default class FileUpload extends Element {
  @api recordId;
  @api label;
  @api title;
  @api name;
  @api accept;
  @api multiple;
  @api disabled;

  handleUploadFinished(event) {
    // Get the list of uploaded files
    const lstOfUploadedFiles = event.detail.files;   
    this.dispatchEvent(new CustomEvent('uploadFinished', { detail: lstOfUploadedFiles }));   
  }
}