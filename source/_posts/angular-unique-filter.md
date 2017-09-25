---
title: angular的unique过滤器
date: 2016-11-24 11:41:07
tags: [javascript,angular]
---

![Angular](http://o93mwnwp7.bkt.clouddn.com/github/ngFilter.jpg)

Angular的过滤器是非常实用的一个功能，过滤器的功能是为了格式化数据，
只要有数据表达式的地方就能使用过滤器。
除去使用默认的几个过滤器，我们还可以自己定义过滤器。

其中`unique`是非常实用的一个过滤器，在`angular-ui`插件中，已经集成了`unique`方法，
可以在[angular-ui/angular-ui-OLDREPO](https://github.com/angular-ui/angular-ui-OLDREPO/blob/master/modules/filters/unique/unique.js)
中看到，代码如下

<!--more-->

```js
/**
 * Filters out all duplicate items from an array by checking the specified key
 * @param [key] {string} the name of the attribute of each object to compare for uniqueness
 if the key is empty, the entire object will be compared
 if the key === false then no filtering will be performed
 * @return {array}
 */
angular.module('ui.filters').filter('unique', function () {

  return function (items, filterOn) {

    if (filterOn === false) {
      return items;
    }

    if ((filterOn || angular.isUndefined(filterOn)) && angular.isArray(items)) {
      var hashCheck = {}, newItems = [];

      var extractValueToCompare = function (item) {
        if (angular.isObject(item) && angular.isString(filterOn)) {
          return item[filterOn];
        } else {
          return item;
        }
      };

      angular.forEach(items, function (item) {
        var valueToCheck, isDuplicate = false;

        for (var i = 0; i < newItems.length; i++) {
          if (angular.equals(extractValueToCompare(newItems[i]), extractValueToCompare(item))) {
            isDuplicate = true;
            break;
          }
        }
        if (!isDuplicate) {
          newItems.push(item);
        }

      });
      items = newItems;
    }
    return items;
  };
});
```

同时，有一个angular插件，提供了不同的filter，[angular-filter](https://github.com/a8m/angular-filter#unique),
可以直接注入该插件，实现我们需要的`unique`过滤器