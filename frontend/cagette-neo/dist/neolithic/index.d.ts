import 'isomorphic-unfetch';
import { ActivateDistribSlotsViewProps } from './views/ActivateDistribSlotsView';
import { UserDistribSlotsSelectorViewProps } from './views/UserDistribSlotsSelectorView';
import { DistribSlotsResolverProps } from './views/DistribSlotsResolver';
export default class NeolithicViewsGenerator {
    static setApiUrl(url: string): void;
    static activateDistribSlots(elementId: string, props: ActivateDistribSlotsViewProps): void;
    static userDistribSlotsSelector(elementId: string, props: UserDistribSlotsSelectorViewProps): void;
    static distribSlotsResolver(elementId: string, props: DistribSlotsResolverProps): void;
}
