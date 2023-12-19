import { Priority } from '../Task';

export class PriorityTools {
    /**
     * Get the name of a {@link Priority} value, returning 'None' for {@link Priority.None}
     * @param priority
     * @see priorityNameUsingNormal
     */
    public static priorityNameUsingNone(priority: Priority) {
        let priorityName = 'ERROR';
        switch (priority) {
            case Priority.High:
                priorityName = '🚨 High';
                break;
            case Priority.Critical:
                priorityName = '🔥 Critical';
                break;
            case Priority.Normal:
                priorityName = '🟢 Normal';
                break;
            case Priority.None:
                priorityName = 'None';
                break;
            case Priority.Low:
                priorityName = '💤 Low';
                break;
            case Priority.Wishlist:
                priorityName = '🔮 Wishlist';
                break;
        }
        return priorityName;
    }

    /**
     * Get the name of a {@link Priority} value, returning 'Normal' for {@link Priority.None}
     * @param priority
     * @see priorityNameUsingNone
     */
    public static priorityNameUsingNormal(priority: Priority) {
        return PriorityTools.priorityNameUsingNone(priority).replace('None', 'No');
    }
}
