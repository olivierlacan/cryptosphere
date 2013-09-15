require 'spec_helper'
require 'cryptosphere/git'
require 'stringio'

describe Cryptosphere::Git::PackReader do
  let(:stringio) { StringIO.new(fixture('packfile')).set_encoding("ASCII-8BIT") }
  subject { described_class.new(stringio) }

  it "returns the next object in the pack" do
    obj = subject.next_object

    expect(obj).to be_a Cryptosphere::Git::PackObject
    expect(obj.type).to eq 1
    expect(obj.length).to eq 189
  end

  it "enumerates all objects in the pack with #each" do
    objects = []
    subject.each { |obj| objects << obj; obj.body }
    expect(objects.size).to eq 3

    expect(objects[0].type).to eq 1
    expect(objects[1].type).to eq 2
    expect(objects[2].type).to eq 3
  end

  it "raises FormatError if fed garbage" do
    expect { described_class.new(StringIO.new("")) }.to raise_exception Cryptosphere::FormatError
    expect { described_class.new(StringIO.new("\0" * 128)) }.to raise_exception Cryptosphere::FormatError
  end
end