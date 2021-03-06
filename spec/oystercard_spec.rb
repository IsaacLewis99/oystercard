require 'Oystercard'
describe Oystercard do
  it 'oyster card displays balance' do 
    expect(subject.balance).to eq(0)
  end
  
  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }
      
    it 'top up the balance' do
      expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
    end
      
    it 'raises an error if the maximum balance is exceeded' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up maximum_balance
      raise_error(RuntimeError, "Maximum balance of #{maximum_balance} exceeded")
    end
      
    describe '#in_journey' do
    
      it 'is initially not in a journey' do
        expect(subject).not_to be_in_journey
      end
    
      it "can touch in" do
        subject.top_up(5)
        subject.touch_in
        expect(subject).to be_in_journey
      end
    
      it "can touch out" do
        subject.top_up(5)
        subject.touch_in
        subject.touch_out
        expect(subject).not_to be_in_journey
      end
    end
    
    it 'will not touch in if below minimum balance' do 
      expect{ subject.touch_in }.to raise_error "Insufficient balance to touch in"
    end
    
    it "it deducts charge after touch in" do
      subject.top_up(10)
      subject.touch_in
      expect{subject.touch_out }.to change{ subject.balance }.by(-Oystercard::MINIMUM_CHARGE)
    end 
    
  end
  
  
  end