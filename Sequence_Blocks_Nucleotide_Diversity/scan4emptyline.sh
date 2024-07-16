for i in *.fst; do
	found=$(grep '^$' $i | wc -l | bc)
	if [ "$found" -gt 1 ]; then
		rm $i
		echo "$i excluded before or after cleaning -> empty line"
	else
		continue
	fi
done

