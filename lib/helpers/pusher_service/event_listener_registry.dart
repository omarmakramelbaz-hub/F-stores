/// Dispatches over a snapshot so callbacks may safely change subscriptions.
class EventListenerRegistry<T> {
  final Map<String, List<void Function(T)>> _listeners = {};

  void add(String eventName, void Function(T) listener) {
    (_listeners[eventName] ??= []).add(listener);
  }

  void remove(String eventName, void Function(T) listener) {
    final listeners = _listeners[eventName];
    listeners?.remove(listener);
    if (listeners == null || listeners.isEmpty) {
      _listeners.remove(eventName);
    }
  }

  void dispatch(String eventName, T event) {
    for (final listener in List<void Function(T)>.of(_listeners[eventName] ?? [])) {
      listener(event);
    }
  }
}
