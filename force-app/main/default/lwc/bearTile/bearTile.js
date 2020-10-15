import { LightningElement, api } from 'lwc';
import My_Resource from '@salesforce/resourceUrl/myResource';
export default class BearTile extends LightningElement {
    spring20Logo = My_Resource + '/images/baloo.jpg';
    @api bear;
	// appResources = {
		// bearSilhouette: `${ursusResources}/img/standing-bear-silhouette.png`,
    // };
    handleOpenRecordClick() {
        const selectEvent = new CustomEvent('bearview', {
            detail: this.bear.Id
        });
        this.dispatchEvent(selectEvent);
    }
}