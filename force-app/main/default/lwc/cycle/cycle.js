import { LightningElement, api } from 'lwc';

export default class Cycle extends LightningElement {
   name = 'Electra X4';
   description = 'A sweet bike built for comfort.';
   category = 'Mountain';
   material = 'Steel';
   price = '$2,700';
   pictureUrl = 'https://s3-us-west-1.amazonaws.com/sfdc-demo/ebikes/electrax4.jpg';
   ready = false;
   connectedCallback() {
       setTimeout(() => {this.ready = true;}, 3000);
   }
   @api Cycle={
       Id : '1234',
       picture : 'https://www.google.com/search?q=beer+explorer+project&rlz=1C1GCEU_enIN919IN919&sxsrf=ALeKk000Emu6A98DJLIAPpQlldBqfgyohw:1602669722407&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiL4vv76bPsAhWU8XMBHYLuA9cQ_AUoAnoECAwQBA&biw=1536&bih=722#imgrc=QWf5NocTUMZuhM'
   };
}