XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]
    then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

nvidia-docker run -it -p 8888:8888 \
        --name ros2e-nvidia \
        --env="DISPLAY=$DISPLAY" \
        --env="QT_X11_NO_MITSHM=1" \
        --shm-size=1g --ulimit memlock=-1 \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        --volume=/home/thenhz/workspace:/code \
        --device=/dev/snd \
        -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
        -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native:Z \
        --group-add $(getent group audio | cut -d: -f3) \
        ros-eloquent-tensorflow-nvidia:1.0 \
        bash