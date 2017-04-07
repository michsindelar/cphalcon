
/*
 +------------------------------------------------------------------------+
 | Phalcon Framework                                                      |
 +------------------------------------------------------------------------+
 | Copyright (c) 2011-2017 Phalcon Team (https://phalconphp.com)          |
 +------------------------------------------------------------------------+
 | This source file is subject to the New BSD License that is bundled     |
 | with this package in the file docs/LICENSE.txt.                        |
 |                                                                        |
 | If you did not receive a copy of the license and are unable to         |
 | obtain it through the world-wide-web, please send an email             |
 | to license@phalconphp.com so we can send you a copy immediately.       |
 +------------------------------------------------------------------------+
 | Authors: Andres Gutierrez <andres@phalconphp.com>                      |
 |          Eduar Carvajal <eduar@phalconphp.com>                         |
 |          Wojciech Ślawski <jurigag@gmail.com>                          |
 +------------------------------------------------------------------------+
 */

namespace Phalcon;

use Phalcon\Factory\Exception;
use Phalcon\Config;

abstract class Factory implements FactoryInterface
{
	protected static function loadClass(string $namespace, var config)
	{
		var className, params;

		let params = self::checkArguments($namespace, config);
		let className = params["className"];

		return new {className}(params["config"]);
	}

	protected static function loadAsArray(string $namespace, var config)
	{
		var params;

		let params = self::checkArguments($namespace, config);

		return [
           	"className" : params["className"],
           	"arguments" : [
           		[
           			"type" : "parameter",
           			"value" : params["config"]
           		]
           	]
        ];
	}

	protected static function checkArguments(string $namespace, var config)
	{
		var adapter, params;

		let params = [];

		if typeof config == "object" && config instanceof Config {
			let config = config->toArray();
		}

		if typeof config != "array" {
			throw new Exception("Config must be array or Phalcon\\Config object");
		}

		if fetch adapter, config["adapter"] {
			unset config["adapter"];
		} else {
			throw new Exception("You must provide 'adapter' option in factory config parameter.");
		}

		let params["config"] = config;
		let params["className"] = $namespace."\\".adapter;

		return params;
	}
}
