/**
 * When sorting, make sure low always comes after none. This way any tasks with low will be below any exiting
 * tasks that have no priority which would be the default.
 *
 * Values can be converted to strings with:
 * - {@link priorityNameUsingNone} in {@link PriorityTools}
 * - {@link priorityNameUsingNormal} in {@link PriorityTools}
 *
 * @export
 * @enum {number}
 */
export enum Priority {
    Critical = '0',
    High = '1',
    Normal = '2',
    None = '3',
    Low = '4',
    Wishlist = '5',
}
