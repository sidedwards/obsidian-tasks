import { Priority } from '../Task/Priority';

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

    /**
     * Get the {@link Priority} value from a string. The algorithm is case-insensitive.
     *
     * In case the value was not recognised, {@link Priority.None} will be returned.
     *
     * @param priority - a string containing a name of one the supported {@link Priority} values.
     *                   Capitalisation is ignored.
     * @see priorityNameUsingNormal
     */
    public static priorityValue(priority: string): Priority {
        switch (priority.toLowerCase()) {
            case 'wishlist':
                return Priority.Wishlist;
            case 'low':
                return Priority.Low;
            case 'normal':
                return Priority.Normal;
            case 'high':
                return Priority.High;
            case 'critical':
                return Priority.Critical;
            default:
                return Priority.None;
        }
    }
}
