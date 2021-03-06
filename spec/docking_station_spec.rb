require 'docking_station'

describe DockingStation do

  let(:bike) { double(:bike, broken?:nil) }
  let(:brokenbike) { double(:bike, broken?:true) }

  it "should change capacity when given an argument" do
    station = DockingStation.new(10)
    expect(station.capacity).to eq 10
  end

  it "should equal the default capacity when no argument is given" do
    expect(subject.capacity).to eq DockingStation::DEFAULT_CAPACITY
  end

  describe '#release_broken_to' do

    it 'should return all the broken bikes' do
      subject.dock(bike)
      broken1, broken2 = brokenbike, brokenbike
      subject.dock(broken1)
      subject.dock(broken2)
      expect(subject.release_broken_to(double(:van))).to eq([broken1,broken2])
    end

    it 'should remove all broken bikes from array' do
      2.times { subject.dock(brokenbike) }
      subject.release_broken_to(double :van)
      expect(subject.release_bike).to raise_error "No more bikes available"
    end
  end

  describe '#release_bike' do

    it 'should release a working bike if any present' do
      subject.dock(bike)
      subject.dock(brokenbike)
      released_bike = subject.release_bike
      expect(released_bike.broken?).to be_falsey
    end

    it 'should raise an error if the docking station is empty when releasing a bike' do
      subject.dock(bike)
      subject.release_bike
      expect{subject.release_bike}.to raise_error "No more bikes available"
    end

    it "should release the same bike as removed" do
      subject.dock(bike)
      subject.dock(brokenbike)
      expect(subject.release_bike).to eq(bike)
    end

    it "should raise an error when trying to release a broken bike" do
      subject.dock(brokenbike)
      expect{subject.release_bike}.to raise_error "All bikes are broken"
    end

  end

  describe '#dock' do

    it "should raise an error when trying to dock more bikes than the capacity" do
      subject.capacity.times{subject.dock(bike)}
      expect { subject.dock(bike) }.to raise_error "Docking Station is full"
    end

  end

end
