class testclass {
# for debug output on the puppet master
notice('testclass successful!')

# for debug output on the puppet client
notify {'testclass successful!':}

}
