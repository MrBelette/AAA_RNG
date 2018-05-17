module AAA_RNG

const cm1 = 259200
const cia1 = 7141
const cic1 = 54773
const crm1 = 3.8580247e-6

const cm2 = 134456
const cia2 = 8121
const cic2 = 28411
const crm2 = 7.4373773e-6

const cm3 = 243000
const cia3 = 4561
const cic3 = 51349

mutable struct AAARNG_State
    state::Vector{Float64}
    IX1::UInt64
    IX2::UInt64
    IX3::UInt64
end

function reseed(nSeed::UInt64, state::AAARNG_State)

    mIX1 = (cic1 - nSeed)
    mIX1 = mod(cia1*mIX1 + cic1, cm1)
    mIX2 = mod(mIX1, cm2)
    mIX1 = mod(cia1*mIX1 + cic1, cm1)
    #mIX2 = mod(cia2*mIX2 + cic2, cm2)
    mIX3 = mod(mIX1, cm3)

    for i=1:97
        mIX1 = mod(cia1*mIX1 + cic1, cm1)
        mIX2 = mod(cia2*mIX2 + cic2, cm2)
        state.state[i] = (mIX1 + (mIX2)*crm2)*crm1
    end

    return AAARNG_State(state.state, mIX1, mIX2, mIX3)

end

mutable struct AAARNG <: AbstractRNG
    seed::UInt64
    state::AAARNG_State
    function AAARNG(seed::Int)
        new(unsigned(seed), reseed(unsigned(seed), AAARNG_State(zeros(97), 0, 0, 0)))
    end
end

const GLOBAL_AAARNG = AAARNG(6499)

function rand(rng::AAARNG=GLOBAL_AAARNG)
    mIX1 = rng.state.IX1
    mIX2 = rng.state.IX2
    mIX3 = rng.state.IX3
    mIX1 = mod(cia1*(mIX1) + cic1, cm1)
    mIX2 = mod(cia2*(mIX2) + cic2, cm2)
    mIX3 = mod(cia3*(mIX3) + cic3, cm3)

    #println(typeof(mIX3))
    #println(mIX3, ", ", 1+Int(round(97*Float64(mIX3)/cm3, RoundDown)))
    j = 1+Int(floor(97*Float64(mIX3)/cm3)) #1 + Int(97*Float64(mIX3)/cm3)

    retval::Float64 = rng.state.state[j]

    u::Float64 = (mIX1 + (mIX2)*crm2)*crm1
    if u<=0.0 || u>=1.0
        u = 1.0 + floor(u) - u
    end

    rng.state.state[j] = u
    rng.state.IX1 = mIX1
    rng.state.IX2 = mIX2
    rng.state.IX3 = mIX3

    return retval
end

end # module
