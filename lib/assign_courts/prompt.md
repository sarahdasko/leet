# Assign Courts to Non-Overlapping Requests

You’re given a list of booking requests for courts. Each request has:

- `id` — unique integer identifier
- `start_time` — integer start timestamp
- `finish_time` — integer finish timestamp, with finish_time > start_time

Two requests *conflict* if their time intervals overlap (i.e., a request starting before another finishes).

## Task

1. Sort the requests by:
    - `start_time` ascending,
    - (`duration` = `finish_time` - `start_time`) ascending,
    - `id` ascending.
1. Assign the requests to the minimum number of courts so that no two requests on the same court overlap.
1. Return the list of courts, each with:
    - `id` — the court number (1-indexed, arbitrary but stable within the output),
    - `bookings` — the list of requests assigned to that court in chronological order.

If multiple courts are available for a request, assign it to the court that becomes free earliest.

> This is the classic “minimum number of resources to schedule intervals” / “meeting rooms II” problem.
