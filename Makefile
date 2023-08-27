#!/usr/bin/make -f

# provides images for the cookbook
#	converts JPG in ./src to PNG with transparency at ./assets,
#	so that the images can be included into LaTeX,
#	so that the gray backgrounds are removed

# REQUIRES
#	ImageMagick
#	wget

# SEE
#	https://www.oldbookillustrations.com/

# AUTHOR
#	Michael Teresi

# FUTURE
#	ImageMagick fuzz is experimental, consider fuzz on a per image basis


MAKEFLAGS += --no-print-directory
IMG_MAGICK_FLAGS += -intensity average -colorspace gray -transparent white -fuzz 25%
_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

###############################################################################

SRC := src
DST := assets
JPG := $(shell find $(SRC) -name '*.jpg')
PNG := $(patsubst %.jpg,%.png,$(JPG))
PNG := $(patsubst $(SRC)/%,$(DST)/%,$(PNG))

all: $(PNG)                                      ## compile assets

clean:                                           ## remove assets
	rm -rf $(DST)

help:                                            ## show usage
	@grep -E '^[a-zA-Z^.(]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

$(DST):
	mkdir -p $(DST)

$(PNG): $(JPG) | $(DST)

$(DST)/%.png : $(SRC)/%.jpg
	convert $< $(IMG_MAGICK_FLAGS) $@


###############################################################################
# download rules, should not be necessary if LFS is used

src/ex_libris_encourage_beautiful.jpg:
	wget https://www.oldbookillustrations.com/site/assets/high-res/1907/ex-libris-encourage-beautiful-1600.jpg -O $@

src/ex_libris_oil_lamp.jpg:
	wget https://www.oldbookillustrations.com/site/assets/high-res/1907/ex-libris-oil-lamp-1600.jpg -O $@

src/ex_libris_peacock.jpg:
	wget https://www.oldbookillustrations.com/site/assets/high-res/1907/ex-libris-peacock-1600.jpg -O $@

src/ex_libris_swan.jpg:
	wget https://www.oldbookillustrations.com/site/assets/high-res/1907/ex-libris-swans-1600.jpg -O $@

src/fly_away.jpg:
	wget https://www.oldbookillustrations.com/site/assets/high-res/1900/fly-away-1600.jpg -O $@

src/grapes.jpg:
	wget https://www.oldbookillustrations.com/site/assets/high-res/1808/gille-tailpiece-grapes-1600.jpg -O $@
	convert $@ -crop 692x350+453+300 $@

