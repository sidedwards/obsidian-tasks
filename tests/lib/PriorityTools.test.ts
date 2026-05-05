import { PriorityTools } from '../../src/lib/PriorityTools';
import { Priority } from '../../src/Task/Priority';

describe('priority naming', () => {
    it.each(Object.values(Priority))('should name priority value: "%i"', (priority) => {
        const name = PriorityTools.priorityNameUsingNone(priority);
        expect(name).not.toEqual('ERROR'); // if this fails, code needs to be updated for a new priority
    });

    it('should name default priority correctly', () => {
        const none = Priority.None;
        expect(PriorityTools.priorityNameUsingNone(none)).toEqual('None');
        expect(PriorityTools.priorityNameUsingNormal(none)).toEqual('Normal');
    });

    it.each([
        // Normal cases
        ['highest', Priority.Critical],
        ['high', Priority.High],
        ['medium', Priority.Normal],
        ['none', Priority.None],
        ['normal', Priority.None],
        ['low', Priority.Low],
        ['lowest', Priority.Wishlist],

        // Erroneous cases
        ['', Priority.None],
        ['invalid_priority_string!', Priority.None],

        // Priority search is case-insensitive
        ['Highest', Priority.Critical],
        ['highEst', Priority.Critical],
    ])('should get priority value for "%s"', (str, value) => {
        expect(PriorityTools.priorityValue(str)).toEqual(value);
    });
});
