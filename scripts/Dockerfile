FROM openjdk:8
RUN apt-get update
ENV PWD /opt/
RUN cd ${PWD}
RUN wget -nc https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
ENV ANDROID_HOME /opt/android-sdk-linux
RUN mkdir -p ${ANDROID_HOME}
RUN unzip -n -d ${ANDROID_HOME} sdk-tools-linux-4333796.zip
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
RUN yes | sdkmanager --licenses
RUN yes | sdkmanager \
      "platform-tools" \
      "build-tools;27.0.3" \
      "platforms;android-27"

RUN apt-get -y install ruby
RUN gem install trollop
