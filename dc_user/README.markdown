# dressed-code

## For .../net/smtp.rb:<x>: [BUG] Segmentation fault

Edit / Build File "~/.rvm/hooks/after_use"  >>  on Mac "/usr/local/rvm/hooks/after_use" put: 
	
	if echo $rvm_ruby_version | grep -q '1.9'; then
	  export RUBYOPT='-r openssl'
	else
	  export RUBYOPT=
	fi

.. now should work !

## without RVM
	
	export RUBYOPT=-r openssl