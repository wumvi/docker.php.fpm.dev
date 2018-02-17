FROM wumvi/php.fpm.prod:7.1
MAINTAINER Vitaliy Kozlenko <vk@wumvi.com>

LABEL version="1.0" php="7.1" mode="dev"

ENV RUN_MODE DEV
ENV PHP_AST v0.1.6
ENV PHP_UOPZ v5.0.2

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get --no-install-recommends -qq -y install git build-essential cmake && \
    apt-get install --no-install-recommends -qq -y php${PHP_VERSION}-xdebug php${PHP_VERSION}-dev && \
	mkdir -p /soft/ && \
	#
	cd /soft/ && \
	git clone https://github.com/nikic/php-ast.git php-ast  && \
	cd php-ast/ && \
	git checkout ${PHP_AST} && \
	phpize  && \
	./configure && \
	make && \
	make install && \
	echo extension=ast.so > /etc/php/${PHP_VERSION}/mods-available/ast.ini && \
	ln -s /etc/php/${PHP_VERSION}/mods-available/ast.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-ast.ini && \
	ln -s /etc/php/${PHP_VERSION}/mods-available/ast.ini /etc/php/${PHP_VERSION}/fpm/conf.d/20-ast.ini && \
	#
	cd /soft/ && \
	git clone https://github.com/krakjoe/uopz.git uopz  && \
	cd uopz/ && \
	git checkout ${PHP_UOPZ} && \
	phpize && \
	./configure && \
	make && \
	make install && \
	echo -e "; configuration for php opcache module\n; priority=5\nextension=uopz.so" > /etc/php/${PHP_VERSION}/mods-available/uopz.ini  && \
	ln -s /etc/php/${PHP_VERSION}/mods-available/uopz.ini /etc/php/${PHP_VERSION}/cli/conf.d/05-uopz.ini && \
	ln -s /etc/php/${PHP_VERSION}/mods-available/uopz.ini /etc/php/${PHP_VERSION}/fpm/conf.d/05-uopz.ini && \
	#
	sed -i 's/display_errors = Off/display_errors = On/' /etc/php/$PHP_VERSION/fpm/php.ini \
	sed -i 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' /etc/php/$PHP_VERSION/fpm/php.ini \
	#
	apt-get -y remove build-essential cmake php${PHP_VERSION}-dev && \
	apt-get -y autoremove && \
	apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
	rm -rf /soft/

EXPOSE 9001 9000
ADD xdebug.ini /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
