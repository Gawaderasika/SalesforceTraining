import { LightningElement } from 'lwc';

export default class HelloWorld extends LightningElement {
    greetings = 'World';
   handleChange(event){
      this.greetings = event.target.value;
   }
}