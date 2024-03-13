import type { Status } from '../Statuses/Status';
import type { Task } from '../Task/Task';

export type EditableTask = {
    // NEW_TASK_FIELD_EDIT_REQUIRED
    description: string;
    status: Status;
    priority: 'none' | 'wishlist' | 'low' | 'normal' | 'high' | 'critical';
    recurrenceRule: string;
    createdDate: string;
    startDate: string;
    scheduledDate: string;
    dueDate: string;
    doneDate: string;
    cancelledDate: string;
    forwardOnly: boolean;
    blockedBy: Task[];
    blocking: Task[];
};
