#!/usr/bin/env python3
from functools import wraps
import requests
import inspect
import json
import hashlib
import os
import time

API_KEY = "YAh5Y/uQPQfzv+n99IxQ9ZOeMyx4epd0gFcVldW4MJtUNw==--vXfYT03Nv8P9q/Vt--dDQXuQWt1QA05VwDamHSDg=="
BASE_URL = "https://api.nexusmods.com/v1/"


def obj_key(obj):
    if inspect.isfunction(obj):
        return [obj.__module__, obj.__name__]
    else:
        return str(obj)

def md5hex(s):
    return hashlib.md5(s.encode(), usedforsecurity=False).hexdigest()

def get_cache_key(*factors):
    return md5hex(json.dumps(factors, sort_keys=True, default=obj_key))


class CacheMiss(Exception):
    pass

class BaseCache(object):
    """
    Simple cache with time-based invalidation
    """
    def cached(self, timeout=None, extra=None):
        """
        A decorator for caching function calls
        """
        # Support @cached (without parentheses) form
        if callable(timeout):
            return self.cached()(timeout)

        def _get_key(func, args, kwargs):
            extra_val = extra(*args, **kwargs) if callable(extra) else extra
            return get_cache_key(func, args, kwargs, extra_val)

        def decorator(func):
            @wraps(func)
            def wrapper(*args, **kwargs):
                cache_key = _get_key(func, args, kwargs)
                try:
                    result = self.get(cache_key)
                except CacheMiss:
                    result = func(*args, **kwargs)
                    self.set(cache_key, result, timeout)

                return result

            def invalidate(*args, **kwargs):
                self.delete(_get_key(func, args, kwargs))
            wrapper.invalidate = invalidate

            def key(*args, **kwargs):
                return CacheKey.make(_get_key(func, args, kwargs), cache=self, timeout=timeout)
            wrapper.key = key

            return wrapper
        return decorator

    def cached_view(self, timeout=None, extra=None):
        if callable(timeout):
            return self.cached_view()(timeout)
        return cached_view_fab(self.cached)(timeout=timeout, extra=extra)


class FileCache(BaseCache):
    """
    A file cache which fixes bugs and misdesign in django default one.
    Uses mtimes in the future to designate expire time. This makes unnecessary
    reading stale files.
    """
    def __init__(self, path, timeout=60*60*24):
        self._dir = path
        self._default_timeout = timeout

    def _key_to_filename(self, key):
        """
        Returns a filename corresponding to cache key
        """
        digest = md5hex(key)
        return os.path.join(self._dir, digest[-2:], digest[:-2])

    def get(self, key):
        filename = self._key_to_filename(key)
        try:
            # Remove file if it's stale
            if time.time() >= os.stat(filename).st_mtime:
                self.delete(filename)
                raise CacheMiss

            with open(filename, 'rb') as f:
                return json.load(f)
        except (IOError, OSError, EOFError):
            raise CacheMiss

    def set(self, key, data, timeout=None):
        filename = self._key_to_filename(key)
        dirname = os.path.dirname(filename)

        if timeout is None:
            timeout = self._default_timeout

        try:
            if not os.path.exists(dirname):
                os.makedirs(dirname)

            # Use open with exclusive rights to prevent data corruption
            f = os.open(filename, os.O_EXCL | os.O_WRONLY | os.O_CREAT)
            try:
                os.write(f, json.dumps(data).encode())
            finally:
                os.close(f)

            # Set mtime to expire time
            os.utime(filename, (0, time.time() + timeout))
        except (IOError, OSError):
            pass

    def delete(self, fname):
        try:
            os.remove(fname)
            # Trying to remove directory in case it's empty
            dirname = os.path.dirname(fname)
            os.rmdir(dirname)
        except (IOError, OSError):
            pass


file_cache = FileCache("nexus-cache/")


headers = {"apikey": API_KEY, "content-type": "application/json"}
# rupd = requests.get(BASE_URL + "games/battlebrothers/mods/updated.json?period=1w", headers=headers)

# rm = requests.get(BASE_URL + "games/battlebrothers/mods/756.json", headers=headers)
# rcl = requests.get(BASE_URL + "games/battlebrothers/mods/756/changelogs.json", headers=headers)

rf = requests.get(BASE_URL + "games/{game_domain_name}/mods/{mod_id}/files.json".format(
    game_domain_name="battlebrothers", mod_id=677), headers=headers)

def main():
    for mod_id in (756,):#(756, 757, 682, 681, 677):

    print(get_something())

@file_cache.cached
def get_something():
    print("get_something")
    return 42
# def cached_get(url):




if __name__ == "__main__":
    main()
