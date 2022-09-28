################################################################################
# Copyright IBM Corporation 2021, 2022
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

FROM registry.access.redhat.com/ubi8/python-38
FROM ruby:2.6

# Need to be root to install dependencies
USER 0

# Install dependencies before the code
WORKDIR /app

COPY ./benchmarks /app/benchmarks
COPY ./service /app/service
COPY ./kg /app/kg
COPY ./config /app/config
COPY ./entity_standardizer /app/entity_standardizer
COPY ./requirements.txt /app/requirements.txt
RUN  python -m pip install --upgrade pip wheel build setuptools; \
     pip install -r entity_standardizer/requirements.txt; \
     cd entity_standardizer; python -m build; pip install dist/entity_standardizer_tca-1.0-py3-none-any.whl; cd ..; \
     pip install -r /app/requirements.txt; \
     python benchmarks/generate_data.py; \
     python benchmarks/run_models.py;

RUN chown -R 1001:0 ./

# Become a non-root user again
USER 1001

# Expose any ports the app is expecting in the environment
ENV PORT 8000
EXPOSE $PORT

ENV GUNICORN_BIND 0.0.0.0:$PORT
CMD ["gunicorn", "--workers=2", "--threads=500", "--timeout", "300", "service:app"]


ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

WORKDIR /usr/src/app

COPY Gemfile just-the-docs.gemspec ./
RUN gem install bundler && bundle install

EXPOSE 4000
