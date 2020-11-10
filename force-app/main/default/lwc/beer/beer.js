import { LightningElement, api } from 'lwc';

export default class Beer extends LightningElement {
   greetings = 'World !!';
   handleChange(event){
      this.greetings = event.targer.value;
   }
}