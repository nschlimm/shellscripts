            echo "Projektname?"
            read projektname
            error=$(cd $projektname 2>&1 )
            echo $error
            echo $error
            pushd $projektname
            ls -a
            popd
