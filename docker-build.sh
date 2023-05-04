
BASE=

docker build \
	--build-arg "base=$(BASE)" \
	--build-arg packages="`cat "packages/$(NAME)" 2>/dev/null`" \
	--build-arg locales="`cat locales`" \
	--no-cache "--iidfile=$(BUILD).iid" .